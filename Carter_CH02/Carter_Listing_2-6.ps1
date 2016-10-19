#Declare Variables In-line

$StringVariable1 = "Hello World"
$StringVariable2 = 123
$StringVariable3 = "123"
$Int32Variable = 123
$SingleVariable = 3.3
$XMLVariable = '<root><MyElement>MyValue</MyElement>'

#Extract Data Types

Clear-Host

"StringVariable1: " + $StringVariable1.GetType()
"StringVariable2: " + $StringVariable2.GetType()
"StringVariable3: " + $StringVariable3.GetType()
"Int32Variable: " + $Int32Variable.GetType()
"SingleVariable: " + $SingleVariable.GetType()
"XMLVariable: " + $XMLVariable.GetType() 
