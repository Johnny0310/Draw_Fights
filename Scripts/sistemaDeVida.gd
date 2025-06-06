class_name BarraSalud extends ProgressBar

func actualizar_barra(maximo: float, actual):
	self.value = actual/(maximo * 1.0)
