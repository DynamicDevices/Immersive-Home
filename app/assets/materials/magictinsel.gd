extends GPUParticles3D

var t0 = null
var t1 = null
func gotinsel(dt1):
	if t1 == null or (dt1.origin - t1.origin).length() > 0.1:
		t1 = dt1
	var ts = t0
	if t0 == null:
		ts = Transform3D(t1)
		ts.origin.z -= 3
	var d = (t1.origin - ts.origin).length()
	if d < 0.1:
		ts = Transform3D(t1)
		ts.origin.z -= 3
		d = 3
	var x = get_tree().create_tween()
	if d > 0.1:
		self.position = t1.origin
		x.tween_property(self, "emitting", true, 0.1)
		x.tween_property(self, "position", ts.origin, d*0.9)
		x.tween_property(self, "emitting", false, 0.1)
		print("tinsel tween length ", d)
	if t0 == null or (t1.origin - t0.origin).length() > 1:
		t0 = t1
