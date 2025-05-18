
.section .text.init
.global init_system
.global _bss_start  
.global _bss_end

init_system:
    // Initialize the BSS section to zero
    ldr x0, =_bss_start
    ldr x1, =_bss_end

.clear_bss:
    cmp x0, x1
    b.ge .bss_done
    str xzr, [x0], #8 /* Store zero in BSS and increment pointer */
    b .clear_bss

.bss_done:
    /* BSS section is now zeroed
     You can add more initialization code here if needed*/

    // Jump to the main kernel function
    bl _kernel_main

    // Infinite loop to prevent falling through