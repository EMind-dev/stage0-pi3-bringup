.section .text.init
.type init_system, %function
.size init_system, . - init_system
.global init_system
.global uart_init
.global kernel
init_system:
    // Set the top of the stack for the current CPU
    // ldr x1, =_stack_top
    // mov sp,x1
    adrp x1, _stack_top
    add sp, x1, :lo12:_stack_top
    // Initialize the BSS section to zero
    // We avoid the use of pseudo-instructions like ldr x1,=_stack_top
    adrp x1, __bss_start
    add x1, x1, :lo12:__bss_start
    adrp x2, __bss_size
    add x2, x2, :lo12:__bss_size

// This way we ensure that the BSS section is zeroed out
// we avoid using pseudo-instructions and its faster then use cbz/cbnz
_clear_bss:
 1: subs x2, x2, #8 // When x2 is zero, we stop the instruction set z flag and b.hi branch is ignored
    str xzr, [x1], #8
    b.hi 1b

_bss_done:
    /* BSS section is now zeroed */
    dsb sy  // Data Synchronization Barrier
    isb      // Instruction Synchronization Barrier
    // We add a barrier to ensure all previous writes are visible
    // to the CPU before proceeding with further initialization
    // Return to the caller
    ret