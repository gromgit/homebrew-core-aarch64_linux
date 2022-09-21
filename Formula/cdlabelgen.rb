class Cdlabelgen < Formula
  desc "CD/DVD inserts and envelopes"
  homepage "https://www.aczoom.com/tools/cdinsert/"
  url "https://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz"
  sha256 "94202a33bd6b19cc3c1cbf6a8e1779d7c72d8b3b48b96267f97d61ced4e1753f"

  livecheck do
    url "https://www.aczoom.com/pub/tools/"
    regex(/href=.*?cdlabelgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cdlabelgen"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "55d7da7fbd64f8e43e47c83d2158551e03c6ee3eaeebe0da1f18bac4e4dda476"
  end

  def install
    man1.mkpath
    system "make", "install", "BASE_DIR=#{prefix}"
  end

  test do
    system bin/"cdlabelgen", "-c", "TestTitle", "-t", share/"cdlabelgen/template.ps", "--output-file", "testout.eps"
    File.file?("testout.eps")
  end
end
