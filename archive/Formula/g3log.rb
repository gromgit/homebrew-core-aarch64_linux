class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.3.4.tar.gz"
  sha256 "2fe8815e5f5afec6b49bdfedfba1e86b8e58a5dc89fd97f4868fb7f3141aed19"
  license "Unlicense"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/g3log"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "865701ab3529c043d5b59fd16e76e6d3168361325828644fea8731360740834a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS.gsub(/TESTDIR/, testpath)
      #include <g3log/g3log.hpp>
      #include <g3log/logworker.hpp>
      int main()
      {
        using namespace g3;
        auto worker = LogWorker::createLogWorker();
        worker->addDefaultLogger("test", "TESTDIR");
        g3::initializeLogging(worker.get());
        LOG(DEBUG) << "Hello World";
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-L#{lib}", "-lg3log", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
