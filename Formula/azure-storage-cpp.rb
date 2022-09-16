class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5a8a1e373496131a0128cfbccb1ae6f5e57fc91eaea968aabfe57767d3370fe0"
    sha256 cellar: :any,                 arm64_big_sur:  "15d27a167c197bca0e649cb241bfdb7f49b2f6f8dbdc9b3ae36aa6562c15f96d"
    sha256 cellar: :any,                 monterey:       "308598850ccde71d7f3f0b95b1f26e257eef415a9cdc140b5da34867555729cb"
    sha256 cellar: :any,                 big_sur:        "778476a3c4cd8f88c475aff98086e9c704f19213eb46d250af145d51a3af8506"
    sha256 cellar: :any,                 catalina:       "fe3ebcd4d1b7454738a7d76113040d6c9fbbbd16ba5265e42101f8575782af89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "072a0ec3117267bc849068e88b6e48579e72904386ac44558e091dfa5e117ea2"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "gettext"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", "Microsoft.WindowsAzure.Storage",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <was/common.h>
      #include <was/storage_account.h>
      using namespace azure;
      int main() {
        utility::string_t storage_connection_string(_XPLATSTR("DefaultEndpointsProtocol=https;AccountName=myaccountname;AccountKey=myaccountkey"));
        try {
          azure::storage::cloud_storage_account storage_account = azure::storage::cloud_storage_account::parse(storage_connection_string);
          return 0;
        }
        catch(...){ return 1; }
      }
    EOS
    flags = ["-std=c++11", "-I#{include}",
             "-I#{Formula["boost"].include}",
             "-I#{Formula["openssl@1.1"].include}",
             "-I#{Formula["cpprestsdk"].include}",
             "-L#{Formula["boost"].lib}",
             "-L#{Formula["cpprestsdk"].lib}",
             "-L#{Formula["openssl@1.1"].lib}",
             "-L#{lib}",
             "-lcpprest", "-lboost_system-mt", "-lssl", "-lcrypto", "-lazurestorage"]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cxx, "-o", "test_azurestoragecpp", "test.cpp", *flags
    system "./test_azurestoragecpp"
  end
end
