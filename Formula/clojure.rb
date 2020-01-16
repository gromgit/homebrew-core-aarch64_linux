class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/clojure-tools-1.10.1.496.tar.gz"
  sha256 "e94a49ffc5ce71833e8e541f4ea5eb645b82989a9900fba86882dafa31c99976"

  bottle :unneeded

  depends_on :java => "1.8+"
  depends_on "rlwrap"

  def install
    system "./install.sh", prefix
  end

  test do
    ENV["TERM"] = "xterm"
    system("#{bin}/clj -e nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
