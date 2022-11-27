class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "6dba28376f3016e49a597d1bb3b9365cdd5ba5cd6e21c848e1c97dca49d6bdaf"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/popeye"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "26ca258adc6a72f54db96885b0aa651534104a49f9ef832b94cdd78139c6fde7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "connect: connection refused",
      shell_output("#{bin}/popeye --save --out html --output-file report.html", 1)
  end
end
