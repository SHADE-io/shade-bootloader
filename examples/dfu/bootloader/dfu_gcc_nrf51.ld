/* Linker script to configure memory regions. */

SEARCH_DIR(.)
GROUP(-lgcc -lc -lnosys)

MEMORY
{
  /** Flash start address for the bootloader. This setting will also be stored in UICR to allow the
   *  MBR to init the bootloader when starting the system. This value must correspond to 
   *  BOOTLOADER_REGION_START found in dfu_types.h. The system is prevented from starting up if 
   *  those values do not match. The check is performed in main.c, see
   *  APP_ERROR_CHECK_BOOL(*((uint32_t *)NRF_UICR_BOOT_START_ADDRESS) == BOOTLOADER_REGION_START);
   */
  FLASH (rx) : ORIGIN = 0x3C000, LENGTH = 0x3C00

  /** RAM Region for bootloader. This setting is suitable when used with s110, s120, s130, s310. */
  RAM (rwx) :  ORIGIN = 0x20002C00, LENGTH = 0x1380

  /** Location of non initialized RAM. Non initialized RAM is used for exchanging bond information
   *  from application to bootloader when using buttonluss DFU OTA. 
   */
  NOINIT (rwx) :  ORIGIN = 0x20003F80, LENGTH = 0x80

  /** Location of bootloader setting in at the last flash page. */
  BOOTLOADER_SETTINGS (rw) : ORIGIN = 0x0003FC00, LENGTH = 0x0400

  /** Location in UICR where bootloader start address is stored. */
  UICR_BOOTLOADER (r) : ORIGIN = 0x10001014, LENGTH = 0x04
}

SECTIONS
{
  /* Ensures the bootloader settings are placed at the last flash page. */
  .bootloaderSettings() :
  {
	
  } > BOOTLOADER_SETTINGS 

  /* Ensures the Bootloader start address in flash is written to UICR when flashing the image. */
  .uicrBootStartAddress : 
  {
    KEEP(*(.uicrBootStartAddress))
  } > UICR_BOOTLOADER

  /* No init RAM section in bootloader. Used for bond information exchange. */
  .noinit(NOLOAD) :
  {

  } > NOINIT
  /* other placements follow here... */
}

INCLUDE "gcc_nrf51_common.ld"
