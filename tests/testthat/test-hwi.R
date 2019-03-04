context("test-hwi")

data(DT)

test_that("hwi works", {
	expect_true(inherits(calc_hwi(DT, 'id', 'group', by = NULL), 'data.table'))

	expect_equal(length(calc_hwi(DT, 'id', 'group', by = 'yr')),
							 DT[, uniqueN(yr)])
})


test_that("hwig works", {
})
