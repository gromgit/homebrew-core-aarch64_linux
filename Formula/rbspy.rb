class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.4.2.tar.gz"
  sha256 "4bd76a63db015401124031929ea7138a2625cb6da6300df45dea491e96046cdc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "8a5b6c32bcd7340e1d1cada7aa7ecda6b79d084b7cecb473d56c4c60678bfcf5"
    sha256 cellar: :any_skip_relocation, catalina: "8be3974da66bc9da1f688164253f3340373083140dce9c4f7364dad2ea2e6263"
    sha256 cellar: :any_skip_relocation, mojave:   "e750469b16a14b6a3cd666c9f051ac1aaf10221c9dfa54a70d6d3177b299da97"
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

    expected_result = "100.00   100.00  aaa - short_program.rb"
    assert_includes File.read("result"), expected_result
  end
end
