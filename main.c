/* *********************************************
   File:        main.c
	 Title:       blink user led
	 Purpose:     LM3S9D96-DK
	              blink user led, spaced by time
                loops
	 Business:    HSA Elektrotechnik
	 Compiler:    MDK-ARM
	 Author/Date: Franz Haunstetter / 03.09.13
	 Comment:     new
   *********************************************
*/

/* includes */
#include <lm3s9d96.h>



int main()
{
	volatile unsigned long ulLoop;

	//
	// Enable the GPIO port that is used for the on-board LED.
	//
	SYSCTL_RCGC2_R = SYSCTL_RCGC2_GPIOF;

	//
	// Do a dummy read to insert a few cycles after enabling the peripheral.
	//
	ulLoop = SYSCTL_RCGC2_R;

	//
	// Enable the GPIO pin for the LED (PF3).  Set the direction as output, and
	// enable the GPIO pin for digital function.
	//
	GPIO_PORTF_DIR_R = 0x08;
	GPIO_PORTF_DEN_R = 0x08;

	//
	// Run the action in a superloop.
	//
	while(1)
	{
		//
		// Toggle the LED.
		//
		GPIO_PORTF_DATA_R ^= 0x08;

		//
		// Delay for a bit.
		//
		for(ulLoop = 0; ulLoop < 200000; ulLoop++)
		{
		}
	}
}
