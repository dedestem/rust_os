@echo off
cls
cd /d %~dp0

set DOCKER_IMAGE=dnos-builder

REM Docker container builder!
docker image inspect %DOCKER_IMAGE% >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Docker image "%DOCKER_IMAGE%" not found.
    echo Building it...
    docker build -t %DOCKER_IMAGE% ../Environment
)

REM Set CARGO_TARGET_DIR inside Docker and build the kernel
docker run --rm -v "%cd%\..\..:/build" -e CARGO_TARGET_DIR=/build/Meta/Target/Rust %DOCKER_IMAGE% bash -c "cd /build && Meta/Environment/linker.ld && cargo clean && cargo build --verbose --target x86_64-unknown-none --release"
if %ERRORLEVEL% neq 0 (
    echo Build process failed inside Docker. Exiting...
    exit /b %ERRORLEVEL%
)
echo 'Build finished'

REM Move the kernel to the ISO directory and create the bootable ISO
echo Moving kernel and creating bootable ISO...
docker run --rm -v "%cd%\..\..:/build" %DOCKER_IMAGE% bash -c "cd /build && mkdir -p Meta/Target/iso/boot/grub"
docker run --rm -v "%cd%\..\..:/build" %DOCKER_IMAGE% bash -c "cp Meta/Environment/grub.cfg Meta/Target/iso/boot/grub/grub.cfg"
docker run --rm -v "%cd%\..\..:/build" %DOCKER_IMAGE% bash -c "rm /build/Meta/Target/iso/boot/dnos-kernel.elf"
docker run --rm -v "%cd%\..\..:/build" %DOCKER_IMAGE% bash -c "objdump -h Meta/Target/Rust/x86_64-unknown-none/release/dnos"
docker run --rm -v "%cd%\..\..:/build" %DOCKER_IMAGE% bash -c "mv /build/Meta/Target/Rust/x86_64-unknown-none/release/dnos /build/Meta/Target/iso/boot/dnos-kernel.elf"
docker run --rm -v "%cd%\..\..:/build" %DOCKER_IMAGE% bash -c "grub-mkrescue -o /build/Meta/Target/dnos.iso /build/Meta/Target/iso"

if %ERRORLEVEL% neq 0 (
    echo Failed to create the ISO. Exiting...
    exit /b %ERRORLEVEL%
)

REM Run the ISO with QEMU
if exist ../Target/dnos.iso (
    echo Running the OS with QEMU...
    qemu-system-x86_64 -cdrom ../Target/dnos.iso
) else (
    echo ISO file not found. Build might have failed. Exiting...
    exit /b 1
)

REM Success
exit /b 0