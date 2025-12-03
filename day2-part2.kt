// Orthodox kotlin - must be runnable without Kotlin Runtime Libraries and only use Java classes!
// notes:
// - can't use kotlin.String - must convert to java.lang.String and the only way I've found to do that without emitting Intrinsics for the null check is calling the copy constructor
// - importing java.lang.String *does* make it take precedence but kotlin still automatically converts java.lang.String returned from Java classes to kotlin.String
// - relies on -Xno-{call,param,receiver}-assertions

@file:JvmName("day2-part2") // this is just here for consistency with other example filenames

import java.lang.String
import java.nio.file.*
import java.util.*

fun main() {
	val scanner = Scanner(Path.of("input/day2.txt"))

	try {
		scanner.useDelimiter(",")

		var result: Long = 0
		var sequenceNo = 0

		while (scanner.hasNext()) {
			result += sumInvalidIDs(String(String(scanner.next()).trim()))
			System.out.println("result after range #$sequenceNo: #$result")
			++sequenceNo
		}
	} finally {
		scanner.close()
	}
}

fun sumInvalidIDs(range: String): Long {
	var result: Long = 0

	val delimeter = range.indexOf("-")

	if (delimeter == -1)
		throw IllegalArgumentException("missing - in range")

	val startStr = range.substring(0, delimeter)
	val endStr = range.substring(delimeter + 1)

	val start = java.lang.Long.parseLong(startStr)
	val end = java.lang.Long.parseLong(endStr)

	if (start > end)
		throw IllegalArgumentException("start is larger than end")

	idLoop@ for (id in start..end) {
		val str = String(java.lang.Long.toString(id))

		for (stride in 1..str.length / 2) {
			if (str.length % stride != 0)
				continue

			var sequence = str.substring(0, stride)

			var i = 0
			var match = true

			while (i < str.length) {
				if (!str.startsWith(sequence, i)) {
					match = false
					break
				}

				i += stride
			}

			if (match) {
				result += id
				continue@idLoop
			}
		} 
	}

	return result
}
