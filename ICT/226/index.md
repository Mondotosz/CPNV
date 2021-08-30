# ICT-226 OOP

## Setup

```ps1
    choco install visualstudio2019enterprise
```

## Theory 1

2 projects

GUI | frontend
Business Logic | backend | dll

.Net 5

## Creating a c# project

Create ClassLibrary

-   New solution
-   ClassLibrary
-   .net 5

Create UI

-   Add new project to solution
-   Console project named HelloWorldCLI
-   Add reference to HelloWorld namespace to HelloWorldCLI

## Abstract data Type

```cs
class Color {
    byte red;
    byte green;
    byte blue;

    public Color(byte red, byte green, byte blue){
        this.red = red;
        this.green = green;
        this.blue = blue;
    }
}

Color color = new Color(255,0,0);


void printColor(Color color)
{
    Console.WriteLine("#%x%x%x", color.red, color.green, color.blue);
}

```
