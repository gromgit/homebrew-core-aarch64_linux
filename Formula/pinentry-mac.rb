class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry"
  url "https://github.com/GPGTools/pinentry/archive/v1.1.0.3.tar.gz"
  sha256 "1ac83f1688d02518da5ddce1ceaa7e40893080a8d2f015b759dfaddf1b14545c"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]
  head "https://github.com/GPGTools/pinentry.git", branch: "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "123dd2e07b5199d9096a4834257e5c000d270e72ecad185b9188578627aa413e" => :big_sur
    sha256 "203acdf241ddeb27258929c6902a8bd2f5f46cb0c4b82d3075cc88ec9a8bd0a1" => :arm64_big_sur
    sha256 "936dba5c3bdd8279e5380012645a349a6ef8c69d1cc9066f28f9c6fa6642fd64" => :catalina
    sha256 "6b2e8f260b2c9d2d7cd3f39516d7794656492cf7726a92a847aa86ba02d83179" => :mojave
    sha256 "aa7a00ec594541e43a74cf7ae16cb05317d5b73c7b6b6647ca349584280eaad7" => :high_sierra
    sha256 "3da6a88abbd4bb04eb2455d8e6998f4fc4db77c3f765d52b7eadf364e82aeaa7" => :sierra
    sha256 "c3d508c96256c50b6a62f9e64fc4cb28810a910927c21f7defbe8af11a3c5961" => :el_capitan
    sha256 "b96a51a263a9447101d4bb8dc4247f324531bd4fd96218f6e170edfc983a87f7" => :yosemite
    sha256 "c2538b57edce2eb7ccc10a32e16ccfbbbe8e61c384c4db8d5a62b04d3815c0ed" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on xcode: :build
  depends_on "gettext"
  depends_on "libassuan"

  def install
    system "autoreconf", "-fiv"
    system "autoconf"
    system "./configure", "--disable-ncurses", "--enable-maintainer-mode"
    system "make"
    prefix.install "macosx/pinentry-mac.app"
    bin.write_exec_script "#{prefix}/pinentry-mac.app/Contents/MacOS/pinentry-mac"
  end

  def caveats
    <<~EOS
      You can now set this as your pinentry program like

      ~/.gnupg/gpg-agent.conf
          pinentry-program #{HOMEBREW_PREFIX}/bin/pinentry-mac
    EOS
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/pinentry-mac --version")
  end
end
