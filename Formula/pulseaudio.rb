class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]

  stable do
    url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-14.2.tar.xz"
    sha256 "75d3f7742c1ae449049a4c88900e454b8b350ecaa8c544f3488a2562a9ff66f1"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pulseaudio"
    sha256 aarch64_linux: "b05d5e1efa25bd67e7a29bf368bd83949bcc7335d51fd56012872b7ffc9a8919"
  end

  head do
    url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "intltool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "speexdsp"

  uses_from_macos "perl" => :build
  uses_from_macos "expat"
  uses_from_macos "m4"

  on_linux do
    depends_on "dbus"
    depends_on "glib"
    depends_on "libcap"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      resource("XML::Parser").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
        system "make", "install"
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-neon-opt
      --disable-nls
      --disable-x11
    ]

    if OS.mac?
      args << "--enable-coreaudio-output"
      args << "--with-mac-sysroot=#{MacOS.sdk_path}"
      args << "--with-mac-version-min=#{MacOS.version}"
    else
      # Perl depends on gdbm.
      # If the dependency of pulseaudio on perl is build-time only,
      # pulseaudio detects and links gdbm at build-time, but cannot locate it at run-time.
      # Thus, we have to
      #  - specify not to use gdbm, or
      #  - add a dependency on gdbm if gdbm is wanted (not implemented).
      # See Linuxbrew/homebrew-core#8148
      args << "--with-database=simple"

      # Tell pulseaudio to use the brewed udev rules dir instead of the system one,
      # which it does not have permission to modify
      args << "--with-udev-rules-dir=#{lib}/udev/rules.d"
    end

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    if OS.linux?
      # https://stackoverflow.com/questions/56309056/is-gschemas-compiled-architecture-specific-can-i-ship-it-with-my-python-library
      rm "#{share}/glib-2.0/schemas/gschemas.compiled"
    end
  end

  service do
    run [opt_bin/"pulseaudio", "--exit-idle-time=-1", "--verbose"]
    keep_alive true
    log_path var/"log/pulseaudio.log"
    error_log_path var/"log/pulseaudio.log"
  end

  test do
    assert_match "module-sine", shell_output("#{bin}/pulseaudio --dump-modules")
  end
end
