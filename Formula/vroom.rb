class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom/archive/v1.10.0.tar.gz"
  sha256 "6426c32133b9ef7a41f88cf4b506848c34feca74fd3fc9b5bf2bcd96a2f436f1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0317ceb98a3b73d216fd32410d8a55c7dbbb36a97ae84986440156848c1fb0c6"
    sha256 cellar: :any, big_sur:       "ae81eeaeb51ed32b5a3ba989672f558f5b9fd95c3e16d2d9c215d1441c358124"
    sha256 cellar: :any, catalina:      "4aba418dd64da25ec0164e6e702279ebce32a8f38f6e35321baa48a203a26ea5"
    sha256 cellar: :any, mojave:        "10564e6caa19a27c671ed27d077733b8aee338a81d75bab37573c7020928981f"
  end

  depends_on "pkg-config" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@1.1"

  def install
    chdir "src" do
      system "make"
    end
    bin.install "bin/vroom"
    pkgshare.install "docs"
  end

  test do
    output = shell_output("#{bin}/vroom -i #{pkgshare}/docs/example_2.json")
    expected_routes = JSON.parse((pkgshare/"docs/example_2_sol.json").read)["routes"]
    actual_routes = JSON.parse(output)["routes"]
    assert_equal expected_routes, actual_routes
  end
end
