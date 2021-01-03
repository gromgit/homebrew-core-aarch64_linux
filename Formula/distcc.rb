class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/3.3.4/distcc-3.3.4.tar.gz"
  sha256 "9d4cddfa8cd510f157c6c082145bc0949e6851e96f5ee907b5948bb6896b7d7b"
  license "GPL-2.0-or-later"
  head "https://github.com/distcc/distcc.git"

  bottle do
    sha256 "6ec64d10966ab54836c6d2888436548df956bb6e171341bf400b2f9298d2f584" => :big_sur
    sha256 "b1889dcef582a41d013d687d376da26819e5206c4955f5aaeb19345afc9d4d18" => :catalina
    sha256 "cc5c3141779bc778f42eadf71acfb4d4cd9a724bc745f763d67002ecf0c480b0" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.9"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20201110.orig.tar.xz"
    sha256 "91e14f26da5bd65e3e74c036e7b7775aec17204fde62aea4b12b686eff2e3911"
  end

  def install
    # While libiberty recommends that packages vendor libiberty into their own source,
    # distcc wants to have a package manager-installed version.
    # Rather than make a package for a floating package like this, let's just
    # make it a resource.
    buildpath.install resource("libiberty")
    cd "libiberty" do
      system "./configure"
      system "make"
    end
    ENV.append "LDFLAGS", "-L#{buildpath}/libiberty"
    ENV.append_to_cflags "-I#{buildpath}/include"

    # Fix for https://github.com/distcc/distcc/issues/408
    inreplace "src/util.c", /\bsd_is_socket_internal/, "not_sd_is_socket_internal"

    # Make sure python stuff is put into the Cellar.
    # --root triggers a bug and installs into HOMEBREW_PREFIX/lib/python2.7/site-packages instead of the Cellar.
    inreplace "Makefile.in", '--root="$$DESTDIR"', ""
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options manual: "distccd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_prefix}/bin/distccd</string>
              <string>--daemon</string>
              <string>--no-detach</string>
              <string>--allow=192.168.0.1/24</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{opt_prefix}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/distcc", "--version"
  end
end
