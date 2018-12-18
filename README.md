# CustomGauceControl

An iOS tutorial written in Swift lang that creates a custom Gauge Control.

Inspired by Paul Hudson from Hacking With Swift fame.

Link to original tutorial:

https://www.hackingwithswift.com/articles/150/how-to-create-a-custom-gauge-control-using-uikit

Things to improve on:
<ol>
<li>Make the label text animate up or down.</li>
<li>Stop the needle from moving below its minimum position – a problem if you animate moving from value 0 to value 100.</li>
<li>Go through all the methods and properties and mark as many as private as you can.</li>
<li>Make the class @IBDesignable and @IBInspectable as much as is possible.</li>
<li>Add an accessibilityLabel that reads the value of the gauge to folks using Voiceover.</li>
<li>Make sure that changing properties triggers a redraw / update of the gauge.</li>
</ol>
