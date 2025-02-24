# Touch
**Inherits:** [Node](https://docs.godotengine.org/de/4.x/classes/class_node.html)
    
## Description

Handles touch events and emits them to the EventSystem

## Properties

| Name                                 | Type                                                                            | Default |
| ------------------------------------ | ------------------------------------------------------------------------------- | ------- |
| [areas_entered](#prop-areas-entered) | [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html)       |         |
| [finger_areas](#prop-finger-areas)   | [Dictionary](https://docs.godotengine.org/de/4.x/classes/class_dictionary.html) |         |

## Methods

| Returns | Name                                                                                                                                                                                                              |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| void    | [_emit_event](#-emit-event) ( type: [String](https://docs.godotengine.org/de/4.x/classes/class_string.html), target: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html) )                  |
| void    | [_init](#-init) ( finger_areas: [Dictionary](https://docs.godotengine.org/de/4.x/classes/class_dictionary.html) )                                                                                                 |
| void    | [_on_area_entered](#-on-area-entered) ( finger_type: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html), area: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html) ) |
| void    | [_on_area_exited](#-on-area-exited) ( finger_type: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html), area: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html) )   |
| void    | [_physics_process](#-physics-process) ( _delta: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html) )                                                                                       |
| void    | [_ready](#-ready) (  )                                                                                                                                                                                            |





## Constants

### Finger = `<Object>` {#const-Finger}

No description provided yet.

## Property Descriptions

### areas_entered: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html) {#prop-areas-entered}

No description provided yet.

### finger_areas: [Dictionary](https://docs.godotengine.org/de/4.x/classes/class_dictionary.html) {#prop-finger-areas}

Record<Finger.Type, Area3D>

## Method Descriptions

###  _emit_event (type: [String](https://docs.godotengine.org/de/4.x/classes/class_string.html) , target: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html)  ) -> void {#-emit-event}

No description provided yet.

###  _init (finger_areas: [Dictionary](https://docs.godotengine.org/de/4.x/classes/class_dictionary.html)  ) -> void {#-init}

No description provided yet.

###  _on_area_entered (finger_type: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html) , area: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html)  ) -> void {#-on-area-entered}

No description provided yet.

###  _on_area_exited (finger_type: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html) , area: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html)  ) -> void {#-on-area-exited}

No description provided yet.

###  _physics_process (_delta: [Variant](https://docs.godotengine.org/de/4.x/classes/class_variant.html)  ) -> void {#-physics-process}

No description provided yet.

###  _ready ( ) -> void {#-ready}

No description provided yet.
