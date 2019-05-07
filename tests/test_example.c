#include <example_module.h>
#include <unity.h>

void setUp(void)
{
  /* This is run before EACH TEST */
}

void tearDown(void)
{
}

void testFunction(void)
{
  TEST_ASSERT_EQUAL(2,sum(1,1));
}

