#![no_std]
#![no_main]

use core::panic::PanicInfo;

/// Panic handler: defines what happens when a panic occurs
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

/// Kernel entry point: _start
#[no_mangle]
pub extern "C" fn _start() -> ! {
    loop {}
}
