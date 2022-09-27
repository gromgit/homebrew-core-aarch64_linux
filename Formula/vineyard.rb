class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.9.0/v6d-0.9.0.tar.gz"
  sha256 "bd1e5ba09c162e1ff046266644bf18065a50ee1a4ad1def483cab62051cadb03"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "f45f713c67eaa655d991a5d2af73af39c29d2fd0deb51ac64384c8a8c24f18e1"
    sha256 arm64_big_sur:  "ee5417404df1dfa58f3a1f3eb98e5ddb05f29d3f8d4a2f6c040d243f7b478b1a"
    sha256 monterey:       "1b1be0a0bbbad02d091d63f881b28a93f78d7e8e884eba04941ce98edadedd13"
    sha256 big_sur:        "92862b30610be2b7b8b658583b3917c914a821ab19c620bbc26ce7157df53e50"
    sha256 catalina:       "0d4ddec53606a8761a7606439548223be706fc4e4cf3040661e31f3a81f3fd33"
    sha256 x86_64_linux:   "1b991335522875b8404f3891056230d53cb11336d748cb91035354850ff694c8"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libgrape-lite"
  depends_on "llvm"
  depends_on "nlohmann-json"
  depends_on "open-mpi"
  depends_on "openssl@1.1"
  depends_on "tbb"

  fails_with gcc: "5"

  def install
    python = "python3.10"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DUSE_EXTERNAL_TBB_LIBS=ON",
                    "-DUSE_EXTERNAL_NLOHMANN_JSON_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <memory>

      #include <vineyard/client/client.h>

      int main(int argc, char **argv) {
        vineyard::Client client;
        VINEYARD_CHECK_OK(client.Connect(argv[1]));

        std::shared_ptr<vineyard::InstanceStatus> status;
        VINEYARD_CHECK_OK(client.InstanceStatus(status));
        std::cout << "vineyard instance is: " << status->instance_id << std::endl;

        return 0;
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{Formula["apache-arrow"].include}",
                    "-I#{Formula["boost"].include}",
                    "-I#{include}",
                    "-I#{include}/vineyard",
                    "-I#{include}/vineyard/contrib",
                    "-L#{Formula["apache-arrow"].lib}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{lib}",
                    "-larrow",
                    "-lboost_thread-mt",
                    "-lboost_system-mt",
                    "-lvineyard_client",
                    "-o", "test_vineyard_client"

    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}/vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n", shell_output("./test_vineyard_client #{testpath}/vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end
