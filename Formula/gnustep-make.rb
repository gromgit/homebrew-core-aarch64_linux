class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "http://gnustep.org"
  url "https://github.com/gnustep/tools-make/releases/download/make-2_9_1/gnustep-make-2.9.1.tar.gz"
  sha256 "c3d6e70cf156b27e7d1ed2501c57df3f96e27488ce2f351b93e479c58c01eae7"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/make[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gnustep-make"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9a7cd686f1e1df0f634c4ad406792d3873160ab3ad3b4f9f09de3e29c0966a88"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install", "tooldir=#{libexec}"
  end

  test do
    assert_match shell_output("#{libexec}/gnustep-config --variable=CC").chomp, ENV.cc
  end
end
