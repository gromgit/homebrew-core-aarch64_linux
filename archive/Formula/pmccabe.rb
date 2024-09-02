class Pmccabe < Formula
  desc "Calculate McCabe-style cyclomatic complexity for C/C++ code"
  homepage "https://gitlab.com/pmccabe/pmccabe"
  url "https://gitlab.com/pmccabe/pmccabe/-/archive/v2.8/pmccabe-v2.8.tar.bz2"
  sha256 "d37cafadfb64507c32d75297193f99f1afcf12289b7fcc1ddde4a852f0f2ac8a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+[a-z]?)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pmccabe"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "73e8fc87529ce7114c8028d5f95efdcbf9f14699c292b0e31d47bdf55a1bdde2"
  end

  def install
    ENV.append_to_cflags "-D__unix"

    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install "pmccabe", "codechanges", "decomment", "vifn"
    man1.install Dir["*.1"]
  end

  test do
    assert_match "pmccabe #{version}", shell_output("#{bin}/pmccabe -V")
  end
end
