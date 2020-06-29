class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.4.tar.gz"
  sha256 "d341e90d3e77c43daa3efb863b4b3501c02ae6610cb8c7215f66cfd934633afb"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "5e1ed5a8c6b4fd0ba5216bcae308778b64cdb2e36c8456b4ccbc16987ac9f4ea" => :catalina
    sha256 "66075d2897bb6690ba17ac0d833060fbecebdbf3855429d8c1182feb5df72197" => :mojave
    sha256 "b03c35ce73313a6e0e675e15575363d0665c5a44e7314d7b2bdc90b18a3ecb1a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  def install
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
