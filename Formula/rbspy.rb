class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.4.3.tar.gz"
  sha256 "12296d3ce2c404b40333e0b4ff54718ac62cd4f2ef196a86a2b81e1f5a563049"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83720cdcb9b4c5b4a8214869f133e49689e376b49c8f36ea367d113855d9fbb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "197d0a96d53dad0c4b4995a243024b0b776542fb3dfee235702dce8f32c7d594"
    sha256 cellar: :any_skip_relocation, catalina:      "23967c3fcd8d1607115c727209ee3ffb5bdb309f57f25c69a3e42adbc74a4604"
    sha256 cellar: :any_skip_relocation, mojave:        "ab19b1c5e47bb7d3a8a4de9cf5cafa6ac788ca6299d4f41261f5caeb6dcc98fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    recording = <<~EOS
      H4sICCOlhlsAA2JyZXdfdGVzdF9yZXN1bHQAvdHBCsIwDAbgu08hOQ/nHKgM8S08iYy0Vlds0
      5J2Dhl7d3eZTNxN8Rb4yf9BwiL4xzKbtRAZpYLi2AKh7QfYyfmlJhm1oz0kwMpg1HdVeoxVH9
      d0I9dQn6AIztRxSKg2JgGjSZGDYtklr0ZEnCgKleNYenZXRrtg8dkI6SEoDmnlrEoFqyYNaL1
      R70uDuBqJQogpcWL7K3I9IqWU/yCz8WF3FvXkk37P5t0pAa/PUOTbfLvpZk/I+tcWQgIAAA==
    EOS

    (testpath/"recording.gz").write Base64.decode64(recording.delete("\n"))
    system "#{bin}/rbspy", "report", "-f", "summary", "-i", "recording.gz",
                           "-o", "result"

    expected_result = <<~EOS
      % self  % total  name
      100.00   100.00  <c function> - unknown
        0.00   100.00  ccc - sample_program.rb
        0.00   100.00  bbb - sample_program.rb
        0.00   100.00  aaa - short_program.rb
        0.00   100.00  <main> - sample_program.rb
    EOS
    assert_includes File.read("result"), expected_result
  end
end
