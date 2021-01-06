class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.56.1/meson-0.56.1.tar.gz"
  sha256 "5780725304eaa28aac5e7de99d2d8d045112fbc10cf9f4181498b877de0ecf28"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dd6a44ed227784bbb0020fa59a260ca02eac5f733f74021f3ae8d7d89baad2d" => :big_sur
    sha256 "b6fe4a48b9af36c0b0f1f143eb531f77c9e97573793e03e28c60c51911d5eabe" => :arm64_big_sur
    sha256 "dcd1ab2cbde30fb8bf327e1ada3b1d87e7f5f17e4c8491ea42ba271c3204578e" => :catalina
    sha256 "0bbd28f770da02450ca6c39c22b129fab56ebe66bd6eb5454c213252629c1afd" => :mojave
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
