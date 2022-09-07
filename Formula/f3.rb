class F3 < Formula
  desc "Test various flash cards"
  homepage "https://fight-flash-fraud.readthedocs.io/en/latest/"
  url "https://github.com/AltraMayor/f3/archive/v8.0.tar.gz"
  sha256 "fb5e0f3b0e0b0bff2089a4ea6af53278804dfe0b87992499131445732e311ab4"
  license "GPL-3.0-only"
  head "https://github.com/AltraMayor/f3.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/f3"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "52e96a6aa833a5bd601cbbf3c40e6b7d457886dc8323cea0605470981590ba70"
  end

  on_macos do
    depends_on "argp-standalone"
  end

  def install
    args = []
    args << "ARGP=#{Formula["argp-standalone"].opt_prefix}" if OS.mac?
    system "make", "all", *args
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
