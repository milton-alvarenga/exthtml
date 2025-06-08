const tasks = new Set();

function run_tasks(now) {
	tasks.forEach(task => {
		if (!task.c(now)) {
			tasks.delete(task);
			task.f();
		}
	});

	if (tasks.size !== 0) exports.raf(run_tasks);
}

function to_number(value) {
	return value === '' ? null : +value;
}