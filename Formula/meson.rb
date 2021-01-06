class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.56.1/meson-0.56.1.tar.gz"
  sha256 "5780725304eaa28aac5e7de99d2d8d045112fbc10cf9f4181498b877de0ecf28"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee262370748d1cc47ff7cb1bb73dc61b38e8fdc38acac0d95d411c4751d01f3f" => :big_sur
    sha256 "ff3035e3f113a4e14574f9e5ab77a2dab7c024ac7be1f9f3a2ee6ef3d4d2647d" => :arm64_big_sur
    sha256 "6002d3295abb3a40094be6364f80cfc184ca848e0dfdef86b16a28288b7fe137" => :catalina
    sha256 "74b2ae9fcf127847952dedf2ea1a89bced31c42ea36ee5f10703385fdae4eec2" => :mojave
    sha256 "3aa272d538cadcc3421fff1bb2ef66ec6edc701668ae3755da525fb467d8be18" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python@3.9"

  def install
    version = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
