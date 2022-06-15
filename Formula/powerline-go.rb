class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.22.1.tar.gz"
  sha256 "f47f31c864bd0389088bb739ecbf7c104b4580f8d4f9143282b7c4158dc53c96"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/powerline-go"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a212427915536cb09cbf65e2e5b40c90a45b98f385b2aa9907e203323182f0de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  test do
    system "#{bin}/#{name}"
  end
end
