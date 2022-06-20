class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://labs.xvid.com/"
  url "https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.bz2"
  sha256 "aeeaae952d4db395249839a3bd03841d6844843f5a4f84c271ff88f7aa1acff7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.xvid.com/downloads/"
    regex(/href=.*?xvidcore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xvid"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "afe0c793e34ae991ebcd08e35203d65e8acbc7faf3db87976948fbb676b3ff91"
  end

  def install
    cd "build/generic" do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <xvid.h>
      #define NULL 0
      int main() {
        xvid_gbl_init_t xvid_gbl_init;
        xvid_global(NULL, XVID_GBL_INIT, &xvid_gbl_init, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxvidcore", "-o", "test"
    system "./test"
  end
end
