class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "934f80e1b09762664d995e7ab5a9932033bc70639e8ceabead817183a54c60d0"
  license "MIT"
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/portmidi"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bd4326afc5e6c175c49d11328338a4a56e54eeba535ce440df7b1950f91e4d2c"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath
    (lib/"pkgconfig").mkpath

    if OS.mac?
      # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
      # "error: expected function body after function declarator" on 10.12
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

      inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

      system "make", "-f", "pm_mac/Makefile.osx"
      system "make", "-f", "pm_mac/Makefile.osx", "install"
      mv lib/shared_library("libportmidi"), lib/shared_library("libportmidi", version)
      # awaiting https://github.com/PortMidi/portmidi/issues/24
      (lib/"pkgconfig").install "Release/packaging/portmidi.pc"
    else
      system "cmake", ".", *std_cmake_args, "-DCMAKE_CACHEFILE_DIR=#{buildpath}/build"
      system "make", "install"
      lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi", 0)
    end
    lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi")
    lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi", version.major.to_s)
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <portmidi.h>

      int main()
      {
        int count = -1;
        count = Pm_CountDevices();
        if(count >= 0)
            return 0;
        else
            return 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lportmidi", "-o", "test"
    system "./test"
  end
end
