## Security Review Guidelines

When reviewing code for security issues, always check for:

### Input Validation
- Validate all user inputs at entry points
- Use allow-lists rather than deny-lists when possible
- Sanitize data before processing

### Authentication & Authorization
- Verify authentication is required for sensitive operations
- Check that users can only access their own data
- Ensure proper session management

### Data Protection
- Look for hardcoded secrets or credentials
- Verify sensitive data is encrypted in transit and at rest
- Check for proper error handling that doesn't leak information

### Common Vulnerabilities
- SQL Injection - Use parameterized queries
- Cross-Site Scripting (XSS) - Escape output properly
- Cross-Site Request Forgery (CSRF) - Use anti-CSRF tokens
- Injection attacks - Validate and sanitize all inputs