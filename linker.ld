ENTRY(_start)
SECTIONS {
  . = 0x80000;

  .text : {
     KEEP(*(.text.boot))
     *(.text .text.* .gnu.linkonce.t*)
  }


    .rodata : { 
    *(.rodata .rodata.* .gnu.linkonce.r*) 
    }

.data : {
  . = ALIGN(8);
  __data_start = .;
  *(.data .data.*)
  __data_end = .;
}

  .bss (NOLOAD) : {
    . = ALIGN(16);
    __bss_start = .;
    *(.bss*)
    *(COMMON)
    __bss_end = .;
  }
  __bss_size = __bss_end - __bss_start;

  . = ALIGN(16);
  _stack_top = . + 0x1000;
  
  _end = .;
   /DISCARD/ : { *(.comment) *(.gnu*) *(.note*) *(.eh_frame*) }

}
