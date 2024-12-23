#![no_std]
#![no_main]

use core::panic::PanicInfo;

// Multiboot header
#[repr(C, packed)]
struct MultibootHeader {
    magic: u32,
    flags: u32,
    checksum: u32,
}

const MULTIBOOT_MAGIC: u32 = 0x1BADB002;
const MULTIBOOT_FLAGS: u32 = 0b00000000000000000000000000000010;
const MULTIBOOT_CHECKSUM: u32 = !(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS);

#[link_section = ".multiboot"]
static MULTIBOOT_HEADER: MultibootHeader = MultibootHeader {
    magic: MULTIBOOT_MAGIC,
    flags: MULTIBOOT_FLAGS,
    checksum: MULTIBOOT_CHECKSUM,
};

/// Panic handler: defines what happens when a panic occurs
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

/// Kernel entry point: _start
#[no_mangle]
pub extern "C" fn _start() -> ! {
    // Your kernel code starts here
    loop {}
}
