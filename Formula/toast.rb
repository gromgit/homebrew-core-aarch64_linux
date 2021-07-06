class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.34.0.tar.gz"
  sha256 "e11e55fcd532fbaf9ebbfb5386d4636793b42e8a0d4a6cf2c29af64457a25774"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b6b6fb7eb40f29fdaee70d466b505b7bb25f3e209cbb93a6921411e481dd217"
    sha256 cellar: :any_skip_relocation, big_sur:       "8fe54aea91d3ebffcdfa098ed913689e34b2385b8094ddfcea601ed3a55dd87f"
    sha256 cellar: :any_skip_relocation, catalina:      "91b6d3c8b66fed63d6c19b24ffb526e40bca9e7e080d5c0a40c151946efbcc3f"
    sha256 cellar: :any_skip_relocation, mojave:        "73edab307a0b7cff590f0c379aa433a264cc5c1960333101c296bba08adc4de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7d969ff1fe90a62a366ab47ebe7ea438c094157c4dc5288e9c120787b78b04"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
