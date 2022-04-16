class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.1.0/fiber-3.1.0.tbz"
  sha256 "077d520b0845c56e10ec5856d7c66ebe7a1f1bea4a3027d182f44b2529519d81"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7b659b9f0863d8db50a59f33f73282f2a6ec2851daf00c6ce129458e610190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "796ce1fcdbab52b5ca13c2e5335c72c1baea068a5c7ba9f776ead96611f0d7a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c9d30d6ac3f470694f3c36a6ee0efcb963dc59aa50d721e484f1bf29a8dd8a84"
    sha256 cellar: :any_skip_relocation, big_sur:        "20061b4e62cc48474f4184a6c0bef2cd4a862d9a1e2a2e888e3da27641c04696"
    sha256 cellar: :any_skip_relocation, catalina:       "7aef99b8ea0e94dd68fd18468c1eaa95d57adf5000d7556af7a2a868e0d47229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0cd68b451e3feac6b943b096ccf6cf1fb89456fad907fd38b5dfbeabc73be6a"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
