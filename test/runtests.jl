using MonoMath
using Test
using Unicode

@testset "MonoMath" begin
  # Check that all codepoints used in the samples are valid Unicode
  for (i, s) in enumerate(MonoMath.text_samples)
    @testset "Sample $i" begin
      for (j, c) in enumerate(s)
        @testset "Codepoint $j ($c = $(repr(codepoint(c))))" begin
          @test Unicode.isassigned(c)
        end
      end
    end
  end
end
