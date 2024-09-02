class Stout < Formula
  desc "Reliable static website deploy tool"
  homepage "https://github.com/cloudflare/Stout"
  url "https://github.com/cloudflare/Stout/archive/v1.3.2.tar.gz"
  sha256 "33aa533beda7181d5efdcfb9fadcc568f58c1f7e27a4902adf1a6807c4875c99"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/stout"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "120fc6606310604e0cd8bf8a1d9e962f925caabdd992d23b8b130a4fac569024"
  end

  # https://github.com/cloudflare/Stout/issues/58
  deprecate! date: "2021-02-21", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    # Compatibility with newer Go.
    # Reported upstream, but the project is unmaintained.
    mkdir_p buildpath/"vendor/github.com/sspencer"
    ln_s buildpath/"vendor/github.com/zackbloom/go-ini", buildpath/"vendor/github.com/sspencer/go-ini"

    mkdir_p buildpath/"src/github.com/cloudflare"
    ln_s buildpath, buildpath/"src/github.com/cloudflare/stout"

    system "go", "build", "-o", bin/"stout", "-v", "github.com/cloudflare/stout/src"
  end

  test do
    system "#{bin}/stout"
  end
end
