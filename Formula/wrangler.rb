class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://www.cs.kent.ac.uk/projects/wrangler/Wrangler/"
  url "https://github.com/RefactoringTools/wrangler/archive/wrangler1.1.01.tar.gz"
  sha256 "e61c13ec772e137efdcf5aa8f21210ef424eac3ee2b918efe5e456985bb19626"

  bottle do
    sha256 "9fb111bc3bf199f301205311fc2b419f4af55924d9741a43038ad01cd2d7284f" => :el_capitan
    sha256 "eba5bb8ddd5db9b8789263b21faa1c9126a4699c67326353fd5a6a22ef5b482b" => :yosemite
    sha256 "dfd60ec29bbd037decd94fd7369a5017182fb803608872b62a214381de29849c" => :mavericks
  end

  depends_on "erlang"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
