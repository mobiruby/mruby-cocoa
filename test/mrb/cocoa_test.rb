class IntValueTest1 < TestCase
  def test_10_parameters
    eq 4, CFunc::Int.size
    eq 4, CFunc::Int.align
  end

  def test_20_set_and_verify
    i = CFunc::Int.new
    i.value = 1
    eq 1, i.value
  end

  def test_30_array
    ci = CFunc::CArray(CFunc::Int).new(10)
    eq 10, ci.size
    for i in 0..9
      ci[i].value = i ** 2
    end
    for i in 0..9
      eq i ** 2, ci[i].value
    end
  end
end
IntValueTest1.run

