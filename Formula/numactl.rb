class Numactl < Formula
  desc "NUMA support for Linux"
  homepage "https://github.com/numactl/numactl"
  url "https://github.com/numactl/numactl/releases/download/v2.0.14/numactl-2.0.14.tar.gz"
  sha256 "826bd148c1b6231e1284e42a4db510207747484b112aee25ed6b1078756bcff6"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", :public_domain, :cannot_represent]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/numactl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cf1bfdc88e86702da61c67cb3a3292ec5eacf884a06a78a5205b6ea815fa84f7"
  end

  depends_on :linux

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <numa.h>
      int main() {
        if (numa_available() >= 0) {
          struct bitmask *mask = numa_allocate_nodemask();
          numa_free_nodemask(mask);
        }
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lnuma", "-o", "test"
    system "./test"
  end
end
