context('test-hwi')

# Load data.table
library(data.table)

# Read example data
DT <- fread(system.file("extdata", "DT.csv", package = "hwig"))


single <- calc_hwi(DT, 'id', 'group', by = NULL)
multiple <- calc_hwi(DT, 'id', 'group', by = 'yr')


test_that('hwi works', {
	expect_true(inherits(single, 'data.table'))

	expect_equal(length(multiple), DT[, uniqueN(yr)])
})


test_that('hwig works', {

		expect_true(inherits(calc_hwig(single), 'data.table'))

		expect_equal(length(calc_hwig(multiple)), DT[, uniqueN(yr)])
})

test_that('get_names works', {

	expect_equal(length(get_names(DT, 'yr')),
							length(multiple))
})

test_that('checks work', {
	# Missing input
	expect_error(calc_hwi(),
							 'DT is missing')

	expect_error(calc_hwi(DT),
							 'id is missing')

	expect_error(calc_hwi(DT, 'id'),
							 'group is missing')

	expect_error(calc_hwig(),
							 'hwi missing. did you run calc_hwi?')

	# Missing/wrong column names
	expect_error(calc_hwi(DT, 'potato', 'group'),
							 'id column not found in DT')

	expect_error(calc_hwi(DT, 'id', 'potato'),
							 'group column not found in DT')

	expect_error(calc_hwi(DT, 'id', 'group', 'potato'),
							 'by column(s) not found in DT', fixed = TRUE)


	# Wrong types
	expect_error(calc_hwig(42),
							 'hwi must be either a data.table or list of data.tables from calc_hwi')

	expect_error(calc_hwig('42'),
							 'hwi must be either a data.table or list of data.tables from calc_hwi')



})
