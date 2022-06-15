class Mlogger < Formula
  desc "Log to syslog from the command-line"
  homepage "https://github.com/nbrownus/mlogger"
  url "https://github.com/nbrownus/mlogger/archive/v1.2.0.tar.gz"
  sha256 "141bb9af13a8f0e865c8509ac810c10be4e21f14db5256ef5c7a6731b490bf32"
  license "BSD-4-Clause-UC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mlogger"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "39de06d4ecade8d9034bb973423b7ede695c54d59bbf59010dbe24a72224a69b"
  end

  def install
    system "make"
    bin.install "mlogger"
  end

  test do
    system "#{bin}/mlogger", "-i", "-d", "test"
  end
end
