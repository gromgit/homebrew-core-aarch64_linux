class VampPluginSdk < Formula
  desc "Audio processing plugin system sdk"
  homepage "https://www.vamp-plugins.org/"
  # curl fails to fetch upstream source, using Debian's instead
  url "https://deb.debian.org/debian/pool/main/v/vamp-plugin-sdk/vamp-plugin-sdk_2.10.0.orig.tar.gz"
  mirror "https://code.soundsoftware.ac.uk/attachments/download/2691/vamp-plugin-sdk-2.10.0.tar.gz"
  sha256 "aeaf3762a44b148cebb10cde82f577317ffc9df2720e5445c3df85f3739ff75f"
  head "https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk", using: :hg

  # code.soundsoftware.ac.uk has SSL certificate verification issues, so we're
  # using Debian in the interim time. If/when the `stable` URL returns to
  # code.soundsoftware.ac.uk, the previous `livecheck` block should be
  # reinstated: https://github.com/Homebrew/homebrew-core/pull/75104
  livecheck do
    url "https://deb.debian.org/debian/pool/main/v/vamp-plugin-sdk/"
    regex(/href=.*?vamp-plugin-sdk[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vamp-plugin-sdk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "25e093bfa7979d2e6f40866c084d6cbc1429d285e89ac7779033076a5d649810"
  end

  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "vamp-sdk/Plugin.h"
      #include <vamp-sdk/PluginAdapter.h>

      class MyPlugin : public Vamp::Plugin { };

      const VampPluginDescriptor *
      vampGetPluginDescriptor(unsigned int version, unsigned int index) { return NULL; }
    EOS

    flags = if OS.mac?
      ["-Wl,-dylib"]
    else
      ["-shared", "-fPIC"]
    end

    system ENV.cxx, "test.cpp", "-I#{include}", *flags, "-o", shared_library("test")
    assert_match "Usage:", shell_output("#{bin}/vamp-rdf-template-generator 2>&1", 2)

    cp "#{lib}/vamp/vamp-example-plugins.so", testpath/shared_library("vamp-example-plugins")
    ENV["VAMP_PATH"]=testpath
    assert_match "amplitudefollower", shell_output("#{bin}/vamp-simple-host -l")
  end
end
