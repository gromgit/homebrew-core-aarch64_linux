class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.9/phpstan.phar"
  sha256 "bb4412f62895747a32aebc31e43957a1ecaae14e7c49ac972be9aae783b3ec6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abda9346ee280d636221cd567f757547cd1a3294535f8e26d97eb24ad6f5aa57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abda9346ee280d636221cd567f757547cd1a3294535f8e26d97eb24ad6f5aa57"
    sha256 cellar: :any_skip_relocation, monterey:       "0813376cca231cfa3f398415afa19ead84fca8e139a01e1f167bc458ba7ca73d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0813376cca231cfa3f398415afa19ead84fca8e139a01e1f167bc458ba7ca73d"
    sha256 cellar: :any_skip_relocation, catalina:       "0813376cca231cfa3f398415afa19ead84fca8e139a01e1f167bc458ba7ca73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abda9346ee280d636221cd567f757547cd1a3294535f8e26d97eb24ad6f5aa57"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
