#touchbook_nand_partitions -> omap3touchbook_nand_partitions
sed -i 's/touchbook_nand_partitions/omap3touchbook_nand_partitions/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_nand_partitions -> omap3touchbook_nand_partitions' -s

#SZ_128K -> NAND_BLOCK_SIZE
sed -i 's/SZ_128K/NAND_BLOCK_SIZE/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: SZ_128K -> NAND_BLOCK_SIZE' -s

#touchbook_mmc -> mmc
sed -i 's/touchbook_mmc/mmc/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_mmc -> mmc' -s

#twl4030_mmc_init -> omap2_hsmmc_init
sed -i 's/twl4030_mmc_init/omap2_hsmmc_init/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: twl4030_mmc_init -> omap2_hsmmc_init' -s

#twl4030_hsmmc_info -> omap2_hsmmc_info
sed -i 's/twl4030_hsmmc_info/omap2_hsmmc_info/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: twl4030_hsmmc_info -> omap2_hsmmc_info' -s

#add #include <linux/mmc/host.h>

#mmc-twl4030.h -> hsmmc.h
sed -i 's/mmc-twl4030.h/hsmmc.h/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: mmc-twl4030.h -> hsmmc.h' -s

#touchbook_i2c_init -> omap3_touchbook_i2c_init
sed -i 's/touchbook_i2c_init/omap3_touchbook_i2c_init/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_i2c_init -> omap3_touchbook_i2c_init' -s

#touchbook_gpio_key_info -> gpio_key_info
sed -i 's/touchbook_gpio_key_info/gpio_key_info/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_gpio_key_info -> gpio_key_info' -s

#touchbook_gpio_led_info -> gpio_led_info
sed -i 's/touchbook_gpio_led_info/gpio_led_info/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_gpio_led_info -> gpio_led_info' -s

#touchbook_gpio_leds -> gpio_leds
sed -i 's/touchbook_gpio_leds/gpio_leds/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_gpio_leds -> gpio_leds' -s

#touchbook_leds_gpio -> leds_gpio
sed -i 's/touchbook_leds_gpio/leds_gpio/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_leds_gpio -> leds_gpio' -s

#touchbook_gpio_buttons -> gpio_buttons
sed -i 's/touchbook_gpio_buttons/gpio_buttons/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_gpio_buttons -> gpio_buttons' -s

#touchbook_keys_gpio -> keys_gpio
sed -i 's/touchbook_keys_gpio/keys_gpio/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_keys_gpio -> keys_gpio' -s

#touchbook_poweroff -> omap3_touchbook_poweroff
sed -i 's/touchbook_poweroff/omap3_touchbook_poweroff/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_poweroff -> omap3_touchbook_poweroff' -s

#touchbook_init_irq -> omap3_touchbook_init_irq
sed -i 's/touchbook_init_irq/omap3_touchbook_init_irq/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_init_irq -> omap3_touchbook_init_irq' -s

#touchbook_init -> omap3_touchbook_init
sed -i 's/touchbook_init/omap3_touchbook_init/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_init -> omap3_touchbook_init' -s

#touchbook_devices -> omap3_touchbook_devices
sed -i 's/touchbook_devices/omap3_touchbook_devices/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_devices -> omap3_touchbook_devices' -s

#touchbook_board_mux -> board_mux
sed -i 's/touchbook_board_mux/board_mux/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_board_mux -> board_mux' -s

#touchbook_i2c_boardinfo_3 -> touchBook_i2c_boardinfo
sed -i 's/touchbook_i2c_boardinfo_3/touchBook_i2c_boardinfo/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_i2c_boardinfo_3 -> touchBook_i2c_boardinfo' -s

#ehci_hcd_omap_platform_data -> usbhs_omap_board_data
sed -i 's/ehci_hcd_omap_platform_data/usbhs_omap_board_data/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: ehci_hcd_omap_platform_data -> usbhs_omap_board_data' -s

#touchbook_ehci_pdata -> usbhs_bdata
sed -i 's/touchbook_ehci_pdata/usbhs_bdata/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_ehci_pdata -> usbhs_bdata' -s

#usb_ehci_init -> usbhs_init
sed -i 's/usb_ehci_init/usbhs_init/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: usb_ehci_init -> usbhs_init' -s

#revision_instance -> early_touchbook_revision
sed -i 's/revision_instance/early_touchbook_revision/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: revision_instance -> early_touchbook_revision' -s

#touchbook_dss_device.dev -> omap3_touchbook_lcd_device.dev
sed -i 's/touchbook_dss_device.dev/omap3_touchbook_lcd_device.dev/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_dss_device.dev -> omap3_touchbook_lcd_device.dev' -s




#touchbook_ads7846_config -> ads7846_pdata
sed -i 's/touchbook_ads7846_config/ads7846_pdata/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: touchbook_ads7846_config -> ads7846_pdata' -s


sed -i 's/X/Y/g' board-omap3touchbook.c.3.0.0
git commit -a -m 'changed: X -> Y' -s




