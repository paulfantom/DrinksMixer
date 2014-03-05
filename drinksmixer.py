#!/bin/python

import sys

def match_ingridients



all_drinks = {
	"Mohito" : ["Long",
		("White rum","40 ml"),
		("Lime juice","20 ml"),
		("Mint leaves","3"),
		("Sugar","2 teaspoons"),
		("Soda","to fill"),
		"Mint muddled with sugar and lime juice. Added rum over ice and topped with soda water."],
	"Long Island Iced Tea" : ["Long",
		("Vodka","15 ml"),
		("Tequila","15 ml"),
		("Triple sec","15 ml"),
		("Rum","15 ml"),
		("Gin","15 ml"),
		("Sweet&Sour","50 ml"),
		("Cola","splash"),
		"Pour all except cola into long glass filled with ice cubes, add cola and stir"]
}

what_next = {
	"i":1,
	"ing":1,
	"d":2,
	"drink":2,
	"r":3,
	"rand":3,
	"a":4,
	"all":4,
	"add":5
}



#print "ing/drink/rand/all/add"
decision = raw_input('ing/drink/rand/all/add?\n')
what_next[decision]