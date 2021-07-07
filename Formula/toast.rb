class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.35.0.tar.gz"
  sha256 "2cef41960dbde8cb5def1dbecfa478c79db5fb7a5be871becf56af58b11cbd9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6527fec067849b1eb161036527fbd21d024115ed4f26e0ac2e403c360a2f9015"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec6511ad803119ad1b6a66bca3073a20bf536941b7821db6cb7f4f5fa4500abc"
    sha256 cellar: :any_skip_relocation, catalina:      "a6fe5fad5e9c401c6960bcd8bfb050a2f87a3cbe54c57cd7b7ff7ff7613609ca"
    sha256 cellar: :any_skip_relocation, mojave:        "45127b4c97eaa8ff9d845da9968e9da6b9080f8695176e02c127acccc0ddf6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7138e65bb1311f644d203f4685058d6d3fa1aa2afffeea52929ee254524838d5"
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
