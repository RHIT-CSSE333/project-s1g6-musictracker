def formatLength(ms):
	if ms is None:
		return ""
	elif ms >= 60 * 60 * 1000:
		return "%d:%02d:%02d.%03d" % (ms // 3600_000, ms // 60000 % 60, ms // 1000 % 60, ms % 1000)
	elif ms >= 60 * 1000:
		return "%d:%02d.%03d" % (ms // 60000, ms // 1000 % 60, ms % 1000)
	else:
		return "%d.%03d" % (ms // 1000, ms % 1000)
