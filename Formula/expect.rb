class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://core.tcl-lang.org/expect/index"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
  sha256 "49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34"
  license :public_domain
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/expect-?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/expect"
    sha256 aarch64_linux: "4dd150eab5ec42aaeba92177b2e9b286f4a664e95c0a204bdd6c5b140589c254"
  end

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "tcl-tk"

  conflicts_with "ircd-hybrid", because: "both install an `mkpasswd` binary"

  def install
    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --enable-shared
      --enable-64bit
      --with-tcl=#{Formula["tcl-tk"].opt_lib}
    ]

    # Temporarily workaround build issues with building 5.45.4 using Xcode 12.
    # Upstream bug (with more complicated fix) is here:
    #   https://core.tcl-lang.org/expect/tktview/0d5b33c00e5b4bbedb835498b0360d7115e832a0
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    # Workaround for ancient config files not recognising aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      cp am_share/fn, "tclconfig/#{fn}"
    end

    # Regenerate configure script. Remove after patch applied in newer
    # releases.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir[lib/"expect*/libexpect*"]
  end

  test do
    system "#{bin}/mkpasswd"
  end
end
